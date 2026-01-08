String moodToEmoji(String mood) {
  switch (mood) {
    case 'Happy':
      return '😊';
    case 'Sad':
      return '😢';
    case 'Angry':
      return '😡';
    case 'Relaxed':
      return '😌';
    default:
      return '🙂';
  }
}

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:34635 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbZJ2XDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 19:03:36 -0400
Received: by iwn10 with SMTP id 10so1751363iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 16:03:41 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 29 Oct 2009 16:03:21 -0700
Message-ID: <43e72e890910291603h1b836cdx378a2a49d7421390@mail.gmail.com>
Subject: fyi - ath9k virtual wiphy - another thing we would need to synch
To: "Jouni.Malinen" <Jouni.Malinen@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sc->sc_ah->opmode

is used and checked for filtering for example, so if another wiphy is
selected it should update its mode there.

  Luis

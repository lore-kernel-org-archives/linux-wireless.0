Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49636 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966461Ab3DQOMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 10:12:02 -0400
Received: by mail-ea0-f171.google.com with SMTP id b15so777415eae.16
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 07:12:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Apr 2013 19:42:00 +0530
Message-ID: <CAFNWPw63zUiD3hqZwujfAxCe2tL1sWfiZL7dMGCKMM0SRapf3A@mail.gmail.com> (sfid-20130417_161207_549046_BFB705BD)
Subject: ath9k multicast packet rate
From: Suja Baburaj <sujababuraj@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi,
I am trying to set the multicast packet rate in the mac80211 and ath9k modules.

Latest kernel seem to support  set_mcast_rate  in mesh mode.

Can somebody please guide me as to why it is not being set in
infrastructure mode ? (Madwifi driver does provide the facility)

Thanks in advance,
suja

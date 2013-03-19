Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55112 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3CSAXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 20:23:33 -0400
Received: by mail-wg0-f54.google.com with SMTP id fm10so5352916wgb.33
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 17:23:32 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC V2 0/2] Enable VHT for non chanctxes drivers
Date: Tue, 19 Mar 2013 01:23:18 +0100
Message-Id: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com> (sfid-20130319_012337_818170_62CDDC9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Johannes, if you could have a look, I included your suggestions.

There is no behavioral differences vs V1 but for the channel switch.
I computed the center_freqs differences to adjust the center_freq{1,2}s.
I know this chswitch part looks bad and won't make it but now I feel like it 
is not worse than the HEAD, so don't panic on it ;).

 
Karl

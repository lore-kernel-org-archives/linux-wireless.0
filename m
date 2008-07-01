Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:10320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYGAQLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 12:11:39 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2314084rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 09:11:39 -0700 (PDT)
Message-ID: <87eacd830807010911r41b32462j5926b379f3dd363f@mail.gmail.com> (sfid-20080701_181201_789456_C6ECAD7C)
Date: Tue, 1 Jul 2008 18:11:39 +0200
From: "Henning Rogge" <hrogge@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Link specific statistics in Adhoc-Mode
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm one person working on the olsr.org mesh routing-daemon. At the
moment we are moving towards using layer 2 data for our routing metric
and I'm looking for a cheap (in terms of cpu power) way to get the
signal strength and bandwith of each link to the neighbors of the
node.

I know both values could be measured by using a raw socket with
radiotap header, but this consumes much too much cpu power on embedded
routers.
I looked at the implementation of the "iw" command, but it does not
contain the necessary information for our metric experiments.

Do you think it would be possible to include this values into the
nl80211 interface ? Is there another way (debugfs?) to get this values
I overlooked ?

Henning

--=20
"Wo k=E4men wir hin, wenn alle sagten, wo k=E4mem wir hin, und niemand
ginge, um einmal zu schauen, wohin man k=E4me, wenn man ginge." (Kurt
Marti)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

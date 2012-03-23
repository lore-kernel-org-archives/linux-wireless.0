Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57317 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2CWArM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 20:47:12 -0400
Received: by iagz16 with SMTP id z16so3852309iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2012 17:47:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201203222035.50568.lindner_marek@yahoo.de>
References: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com>
	<201203221958.10427.lindner_marek@yahoo.de>
	<CAPjQAd-j0mP9faqSkwuDWErX1v+dbzYqO+rL6sKN-2ZMYr_FGA@mail.gmail.com>
	<201203222035.50568.lindner_marek@yahoo.de>
Date: Fri, 23 Mar 2012 08:47:12 +0800
Message-ID: <CAEFj986ZP6bPBNXY2OtjyM_Sn8F1dUsZOAPTE_bSkAE6==Tx0w@mail.gmail.com> (sfid-20120323_014727_522207_96260335)
Subject: Re: [PATCH v2] mac80211: fix the RANN propagation issues
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	thomas@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Marek

Thanks. Appreciate your comments. HWMP sequence number is 32bits or 4
octets. That's why it is defined as u32.

Hi, Javier

Thanks for your explanation and clarification.

I will resubmit the patch for the changes.

"In the section 11C.9.8.3 HWMP sequence numbering, Comparing HWMP
sequence numbers is done using a circular modulo 232 comparison."

Regards,
Chun-Yeow

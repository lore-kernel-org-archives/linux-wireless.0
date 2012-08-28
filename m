Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33596 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2H1Hmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 03:42:55 -0400
Received: by obbuo13 with SMTP id uo13so9902799obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 00:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVNZYM6hQe9BvhP2eyFCMWTk7-HbZBx9hqikwQNkdF_6cQ@mail.gmail.com>
References: <1346063887-29078-1-git-send-email-yeohchunyeow@gmail.com>
	<CAG6hwVMQckH9KYp=OZorb2Q__91VrC-V5MNqE+zXsCTN4B5=dg@mail.gmail.com>
	<CAEFj984VD6VmnX5nP0bCV7-pb-YPQ55eX2Gusg4G4jwRV7O9ng@mail.gmail.com>
	<CAG6hwVNZYM6hQe9BvhP2eyFCMWTk7-HbZBx9hqikwQNkdF_6cQ@mail.gmail.com>
Date: Tue, 28 Aug 2012 15:42:54 +0800
Message-ID: <CAEFj984iZqFYoJNSYPHYZvYkYatUPnmOtV2q9gDtsf8xwAWR1w@mail.gmail.com> (sfid-20120828_094258_816037_EF77A11A)
Subject: Re: [PATCH] cfg80211: allow software encryption of aes cmac in mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Thomas

> But this is ugly. I liked your ath5k patch better and am not really
> sure what Johannes' problem with it was?

Further investigation seems that MFP can be supported in hardware.

Let me resubmit a patch on ath5k and see what are the comments coming
from ath5k developers.

Thanks

---
Chun-Yeow

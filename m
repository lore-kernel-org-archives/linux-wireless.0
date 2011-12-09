Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35676 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1LITmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 14:42:50 -0500
Received: by vbbfc26 with SMTP id fc26so2576010vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 11:42:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323427001.3622.14.camel@jlt3.sipsolutions.net>
References: <1323427001.3622.14.camel@jlt3.sipsolutions.net>
Date: Sat, 10 Dec 2011 06:42:49 +1100
Message-ID: <CAJ-VmomHfArfn6sQhPb=k8cP_MJ-MX5rk1c1g8JgFp=1ce9adQ@mail.gmail.com> (sfid-20111209_204252_568772_3091FE2B)
Subject: Re: ath9k: reports wrong GI/bandwidth (bug)
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you see whether the -final- frame in an A-MPDU has the correct GI bit set?


adrian

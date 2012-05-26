Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3481 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2EZGiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 02:38:46 -0400
Message-ID: <4FC07A67.6010704@broadcom.com> (sfid-20120526_083850_898636_FBF35F37)
Date: Sat, 26 May 2012 08:38:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: "Seth Forshee" <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"Kalle Valo" <kvalo@qca.qualcomm.com>
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <4FC00848.9060901@broadcom.com>
 <CAB=NE6XsTtJvmJDVa2toJCsjn1fxH+5cqJ8xkaquNhHcHDgh2A@mail.gmail.com>
In-Reply-To: <CAB=NE6XsTtJvmJDVa2toJCsjn1fxH+5cqJ8xkaquNhHcHDgh2A@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2012 12:51 AM, Luis R. Rodriguez wrote:
>> It took a while. There were some discussions and we agreed that your
>> > changes establish a better integration with the regulatory framework.
>> > There are some concerns about the content of the crda database, but that
>> > is another thing outside the scope of your patches.
> BTW if you would like to address anything please let me know. If you'd like
> to review things in private too that's fine, just let me know. I
> should say that the staging area for the next generation regulatory
> code is being done through the regulatory simulator:
> 
> git://github.com/mcgrof/regsim.git

Thanks, Luis. I mainly focused on the crda database and it has a
relation freqs<->pwr_limit. In our regulatory code we make a distinction
between 11n and abg as we believe that is necessary. Another example
would be 20MHz transmission in 40MHz channel. Maybe that is taken into
account in crda code, but I did not have a close look at it yet.

I will have a look at the regsim repository and follow up on that.

> Arend, in the future please trim all hunks that are not relevant to
> your replies, that makes review easier.

Will do.

Gr. AvS


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:62440 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbZASMiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 07:38:01 -0500
Received: by bwz14 with SMTP id 14so8283081bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 04:37:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1231864769.20912.2.camel@rc-desk>
References: <496C3F37.4030808@gmail.com> <1231864769.20912.2.camel@rc-desk>
Date: Mon, 19 Jan 2009 14:37:59 +0200
Message-ID: <31436f4a0901190437o5777eb64ua859e2da04654273@mail.gmail.com> (sfid-20090119_133808_548195_479138AE)
Subject: Re: 802.11n status (iwlagn)
From: David Shwatrz <dshwatrz@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Jason Newton <nevion@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Two questions regarding this topic:

1)does latest wireless-testing git tree
support 802.11n in 5100AGN-based chips ?

2)Is the TX aggregation problem is also the same and relevant to 5100AGN?

Regards,
DavidS



On Tue, Jan 13, 2009 at 6:39 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Mon, 2009-01-12 at 23:13 -0800, Jason Newton wrote:
>> Hi all,
>>
>> I've been searching around for a long time now and I find it difficult
>> to understand what the current status of 802.11n is in linux as a whole
>> and what it is with respect to iwlagn (4965 chipset specifically).  I
>> want high-speed and reliable wireless :-)
>>
>> Also, it would seem iwlagn n/ht still isn't working in 2.6.28?
>>
>> To anyone who can clear all this up for me, I'd be much appreciative.
>>
>
> 802.11n does work in 2.6.28 - the speed is not there as changes in the
> kernel caused breakage of TX aggregation. Other functionality of HT was
> not affected. We recently started looking at getting TX aggregation
> working again.
>
> Reinette
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

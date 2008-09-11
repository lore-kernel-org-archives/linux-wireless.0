Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:55383 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYIKS4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 14:56:49 -0400
Received: by mu-out-0910.google.com with SMTP id g7so317182muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 11:56:48 -0700 (PDT)
Message-ID: <aa050c750809111156s41d4cfcbnc79ed65687f97348@mail.gmail.com> (sfid-20080911_205652_812983_7E69B266)
Date: Thu, 11 Sep 2008 11:56:47 -0700
From: "Anna Neal" <anna@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control via SIOCSIWTXPOW.
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1221158234.6986.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48c964bf.1b018e0a.75a0.0ecf@mx.google.com>
	 <1221158234.6986.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 11:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-09-11 at 11:17 -0700, Anna Neal wrote:
>
>> +/**
>> + * @brief Configures the transmission power control functionality.
>> + *
>> + * @param priv               A pointer to struct lbs_private structure
>> + * @param enable     Transmission power control enable
>> + * @param p0         Power level when link quality is good (dBm).
>> + * @param p1         Power level when link quality is fair (dBm).
>> + * @param p2         Power level when link quality is poor (dBm).
>> + * @param usesnr     Use Signal to Noise Ratio in TPC
>> + *
>> + * @return 0 on success
>
> What doc tools are you using? This isn't kernel-doc notation, is it?

Thanks for the feedback,

I was just trying to be consistent with the rest of the file. I am not
currently using kernel-doc.

Maybe its worth it, in a subsequent patch, to convert the whole file
to kernel-doc notation?

Any volunteers?

Anna

>
> [not that I think that should prevent the patch from going in, at this
> point, since I don't think the file is read by kernel-doc anyway]
>
> johannes
>

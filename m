Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49971 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2K0VBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 16:01:42 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so9426748vcm.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 13:01:41 -0800 (PST)
Message-ID: <50B52A33.3060900@gmail.com> (sfid-20121127_220145_784810_A9D37CCE)
Date: Tue, 27 Nov 2012 16:01:39 -0500
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] Add spectral scan support for Atheros AR92xx/AR93xx
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de> <loom.20121127T201036-82@post.gmane.org> <20121127194952.GA530@pandem0nium> <20121127203244.GA752@pandem0nium>
In-Reply-To: <20121127203244.GA752@pandem0nium>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On 11/27/2012 03:32 PM, Simon Wunderlich wrote:
> On Tue, Nov 27, 2012 at 08:49:52PM +0100, Simon Wunderlich wrote:
>> [...]
>>
>> The goal of this was to create the spectral scan feature based on public
>> information, so the results are probably not optimal yet, but I hope that
>> this will help to move Qualcomm/Atheros disclosing some information (this seems
>> to be planned anyway[2]). Otherwise, maybe other people can help
>> reverse-engineering this. :)
> Just to clarify: I don't mean anyone should disassemble proprietary object files
> or use proprietary source code and re-use these findings without permission to
> create this feature - this would probably be illegal anyway.
>
> By reverse-engineering, I mean we can already dump data spectral scan data with
> this patchset, but the hard part is to interpret this data correctly - as you'll
> find in the patches, there are a lot of bits which we don't know what they
> mean, and maybe there is even more info hidden in these bits. I've uploaded
> some samples taken on my hardware to the github repo, so anyone can use my
> program, matlab, or just stare at these heaps of bytes to find some patterns and
> try to interpret it. Actually I was just staring at the bytes myself and wrote
> this visualizer to get a better idea what they could mean.
>
> Of course, if we can some docs or support from QCA officially, this would be even
> better. :)
>
> Cheers,
> 	Simon
A search brought me to their patent application. The Drawings on their 
patent application contain some more information on the signal 
classifications. Hopefully this will be able to help you or someone else.

http://www.google.com/patents/US7929508

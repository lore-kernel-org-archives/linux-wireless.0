Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:59807 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZFCMyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 08:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <1244033004.21215.4.camel@deadeye>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com>
	 <1244021629-18409-2-git-send-email-dbaryshkov@gmail.com>
	 <1244033004.21215.4.camel@deadeye>
Date: Wed, 3 Jun 2009 16:48:08 +0400
Message-ID: <bc64b4640906030548v2825961ck7fb44ded5d32c376@mail.gmail.com>
Subject: Re: [PATCH 1/6] crc-itu-t: add bit-reversed calculation
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, davem@davemloft.net,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Sergey Lapin <slapin@ossfans.org>,
	Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/3 Ben Hutchings <ben@decadent.org.uk>:
> On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
> [...]
>> +/**
>> + * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the data buffer;
>> + * the buffer content is assumed to be bit-reversed
> [...]
>
> This short description spills onto two lines which is invalid and breaks
> the generation of docs.  Sorry to point this out after recommending the
> patch to you.
>
> I've changed the description to "crc_itu_t_bitreversed - Compute the
> CRC-ITU-T for a bit-reversed data buffer" all on one line.

Changing patch here in accordance with your suggestion.

-- 
With best wishes
Dmitry

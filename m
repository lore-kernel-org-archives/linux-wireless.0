Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54952 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZKYOph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 09:45:37 -0500
Received: by bwz27 with SMTP id 27so6959948bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 06:45:42 -0800 (PST)
Cc: Pat Erley <pat-lkml@erley.org>, linux-wireless@vger.kernel.org
Message-Id: <D0FDC725-10F7-473E-995F-EC842DB8AC18@gmail.com>
From: Rui Paulo <rpaulo@gmail.com>
To: Simon Perreault <simon.perreault@viagenie.ca>
In-Reply-To: <4B0D360A.3080801@viagenie.ca>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Hardware for 802.11s
Date: Wed, 25 Nov 2009 14:45:38 +0000
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org> <4B0D360A.3080801@viagenie.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 Nov 2009, at 13:50, Simon Perreault wrote:

> Thanks for your reply.
>
> Pat Erley wrote, on 2009-11-24 17:56:
>> I don't have time tonight, but I believe you can make b43 work by  
>> triggering a
>> scan after bringing the interface up.  I know I've made b43 work in  
>> the past.
>
> What do you mean, "triggering a scan"? What command line does that  
> translate into?

Try iwlist mesh0 scanning.

--
Rui Paulo


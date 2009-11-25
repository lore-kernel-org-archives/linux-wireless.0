Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:40432 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbZKYPgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 10:36:55 -0500
MIME-Version: 1.0
Date: Wed, 25 Nov 2009 10:36:59 -0500
From: <pat-lkml@erley.org>
To: Simon Perreault <simon.perreault@viagenie.ca>
Cc: Rui Paulo <rpaulo@gmail.com>, <linux-wireless@vger.kernel.org>
Subject: Re: Hardware for 802.11s
In-Reply-To: <4B0D4E98.5090600@viagenie.ca>
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org> <4B0D360A.3080801@viagenie.ca> <D0FDC725-10F7-473E-995F-EC842DB8AC18@gmail.com> <4B0D4E98.5090600@viagenie.ca>
Message-ID: <66c7012a2fea8a9dd6fbdf30d0a44410@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 25 Nov 2009 10:34:48 -0500, Simon Perreault
<simon.perreault@viagenie.ca> wrote:
> Rui Paulo wrote, on 2009-11-25 09:45:
>> Try iwlist mesh0 scanning.
> 
> The output of that looks very much like that of "iw dev mesh0 scan" with
> different formatting.
> 
> It doesn't help. "iw dev mesh0 station dump" is still empty.

Did you do that on both ends?  What is the full procedure you're using to
set up the mesh interfaces on the nodes?  

Pat Erley

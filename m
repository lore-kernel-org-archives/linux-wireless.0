Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jazz.viagenie.ca ([206.123.31.2]:39595 "EHLO jazz.viagenie.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZKYPem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 10:34:42 -0500
Message-ID: <4B0D4E98.5090600@viagenie.ca>
Date: Wed, 25 Nov 2009 10:34:48 -0500
From: Simon Perreault <simon.perreault@viagenie.ca>
MIME-Version: 1.0
To: Rui Paulo <rpaulo@gmail.com>
CC: Pat Erley <pat-lkml@erley.org>, linux-wireless@vger.kernel.org
Subject: Re: Hardware for 802.11s
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org> <4B0D360A.3080801@viagenie.ca> <D0FDC725-10F7-473E-995F-EC842DB8AC18@gmail.com>
In-Reply-To: <D0FDC725-10F7-473E-995F-EC842DB8AC18@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rui Paulo wrote, on 2009-11-25 09:45:
> Try iwlist mesh0 scanning.

The output of that looks very much like that of "iw dev mesh0 scan" with
different formatting.

It doesn't help. "iw dev mesh0 station dump" is still empty.

Thanks,
Simon
-- 
DNS64 open-source   --> http://ecdysis.viagenie.ca
STUN/TURN server    --> http://numb.viagenie.ca
vCard 4.0           --> http://www.vcarddav.org

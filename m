Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39966 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3AXQ1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 11:27:41 -0500
Received: by mail-ob0-f171.google.com with SMTP id lz20so4320895obb.30
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 08:27:41 -0800 (PST)
Message-ID: <510160FA.2020002@lwfinger.net> (sfid-20130124_172759_762449_18DCD562)
Date: Thu, 24 Jan 2013 10:27:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?EUC-KR?B?IrHiu/O/+CAoU1cgS2kpIg==?= <oprsystem@telechips.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [question] how can i make to 32bit aligned address for the 'data'
 field of sk_buff structure ?
References: <F4F751F96C54D346898D4C77E196E3DB0A3F6C6D@telegweb.telechips.com>
In-Reply-To: <F4F751F96C54D346898D4C77E196E3DB0A3F6C6D@telegweb.telechips.com>
Content-Type: text/plain; charset=EUC-KR
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2013 05:58 AM, ±â»ó¿ø (SW Ki) wrote:
> hello everyone.
> 
> i have question. i want to use DMA for the 'data' field of sk_buff structure.
> but sometimes, the 'data' field of sk_buff structure is not 32bit aligned.
> so, how can i make to 32bit aligned address for the 'data' field of sk_buff structure ?

A standard sk_buff should meet all the alignment requirements for your
architecture. Could you provide more details about your architecture and an
example where the sk_buff does not have the correct alignment?

Larry



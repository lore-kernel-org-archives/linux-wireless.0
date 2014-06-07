Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34932 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaFGHc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 03:32:59 -0400
Received: by mail-pb0-f44.google.com with SMTP id rq2so3424124pbb.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 00:32:59 -0700 (PDT)
Message-ID: <5392C027.3020808@gmail.com> (sfid-20140607_093303_009607_1DB71581)
Date: Sat, 07 Jun 2014 15:32:55 +0800
From: Fred Chou <fred.chou.nd@gmail.com>
MIME-Version: 1.0
To: Gaurav Kumar Chauhan <ck.gaurav@globaledgesoft.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Physical carrier sensing (CCA)
References: <539030ED.4020006@globaledgesoft.com>
In-Reply-To: <539030ED.4020006@globaledgesoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 04:57 PM, Gaurav Kumar Chauhan wrote:

> I tried to google it but didn't get more than basics. I want to know
> about physical carrier
> sensing in detail and where code for physical sensing is present.
> 
> Is it in driver or in firmware?

Had similar question before, and after some survey, my understanding is
physical carrier sensing is done by hardware, and in firmware you only
need to read some status register find out sensing result.
Correct me if I am wrong.

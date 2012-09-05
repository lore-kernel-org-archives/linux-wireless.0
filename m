Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51229 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2IEUTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 16:19:06 -0400
Received: by eekc1 with SMTP id c1so400879eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 13:19:05 -0700 (PDT)
References: <1346019997-14487-1-git-send-email-mkl@blackshift.org> <CAOZOX0VBUZzGYnAM1O4Do7VyskpjXUE5ewW=qtW7JsbKJtLAMQ@mail.gmail.com> <50470E54.6030801@blackshift.org>
In-Reply-To: <50470E54.6030801@blackshift.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <CF352CE5-5239-4417-B664-D4F6DE398A22@gmail.com> (sfid-20120905_221911_356879_B69D0CC3)
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: fix votage setting for RT3572/RT3592
Date: Wed, 5 Sep 2012 22:19:02 +0200
To: Marc Kleine-Budde <mkl@blackshift.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marc,

Sent from my iPad

On 5 sep. 2012, at 10:33, Marc Kleine-Budde <mkl@blackshift.org> wrote:

> On 08/27/2012 10:19 AM, Ivo Van Doorn wrote:
>> On Mon, Aug 27, 2012 at 12:26 AM, Marc Kleine-Budde <mkl@blackshift.org> wrote:
>>> According to the vendor driver v2.6.0.1, during the rf register init the SRAM
>>> voltage should be increased to 1.35V and after 1ms decreased back to 1.2V. This
>>> patch adds the field setting of LDO_CFG0_LDO_CORE_VLEVEL accordingly.
>>> 
>>> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
>>> Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
>> 
>> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Ping. Is someone taking care of this patch?
> 

Normally, John takes these patches after Ivo, Helmut or I have acked them.
However, I believe he was travelling last week, so it takes a bit longer to be applied.

---
Gertjan

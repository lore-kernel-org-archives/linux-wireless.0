Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39478 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZD1USE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 16:18:04 -0400
Received: by fxm2 with SMTP id 2so781020fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 13:18:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090428185709.GA3321@tuxdriver.com>
References: <200904261608.30384.IvDoorn@gmail.com>
	 <200904261608.50411.IvDoorn@gmail.com>
	 <200904261609.11447.IvDoorn@gmail.com>
	 <20090428185709.GA3321@tuxdriver.com>
Date: Tue, 28 Apr 2009 22:18:02 +0200
Message-ID: <a32f33a40904281318r7b26e5c2ja5ebefe19ecaa089@mail.gmail.com> (sfid-20090428_221815_008175_98CF88AD)
Subject: Re: [PATCH 3/5] rt2x00: Fix the interval for rfkill and link_tuner.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Alban Browaeys <prahal@yahoo.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2009 at 8:57 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sun, Apr 26, 2009 at 04:09:11PM +0200, Ivo van Doorn wrote:
>> From: Alban Browaeys <prahal@yahoo.com>
>>
>> extra parenthesis made the value an argument and the value of the
>> define empty. This was triggering those very fast.
>>
>> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>
> ???
>
> If that were so, wouldn't that have caused compile-time errors?

I've CCed Alban so he can explain the issue he experienced..

For me this patch is just a style-fix, because those
parenthesis were useless anyway.

Ivo

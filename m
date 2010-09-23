Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48002 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab0IWUbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 16:31:37 -0400
Received: by iwn5 with SMTP id 5so1700332iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 13:31:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <718868.40588.qm@web56806.mail.re3.yahoo.com>
References: <AANLkTik6r_xUD4Ct2iuWWbXPLUnDYb1HPzLTaym=GW8L@mail.gmail.com> <718868.40588.qm@web56806.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Sep 2010 13:31:15 -0700
Message-ID: <AANLkTinxnqKqXLgTrgCK5L54A3QXum6yYxNVHrWVqLjC@mail.gmail.com>
Subject: Re: Compiling carl9170
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 12:10 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
>
>> Yes, distributions should pick carl9170 over ar9170 though
>> as ar9170
>> will be removed from the kernel after a good kernel try out
>> of it.
>>
>>   Luis
>
> Sounds logical. Shouldn't ar9170 be disabled by default via config.mk
> in compat-wireless to prevent collision with carl9170 before its completely removed?

Sure.

  Luis

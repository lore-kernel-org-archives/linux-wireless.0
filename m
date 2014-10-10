Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:38674 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJJGMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 02:12:24 -0400
Received: by mail-la0-f53.google.com with SMTP id gq15so2529519lab.40
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 23:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412843805.1828.24.camel@jlt4.sipsolutions.net>
References: <1410778078-25244-1-git-send-email-janusz.dziedzic@tieto.com>
	<1412843805.1828.24.camel@jlt4.sipsolutions.net>
Date: Fri, 10 Oct 2014 08:12:22 +0200
Message-ID: <CALhHN=qk9txQR1EU-AoDLio4e+z_3c-3gui_x9yTt-1EqhqPzw@mail.gmail.com> (sfid-20141010_081228_139036_8BCF6770)
Subject: Re: [PATCH v2 2/2] iw: add vendor send command
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 October 2014 10:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-09-15 at 12:47 +0200, Janusz Dziedzic wrote:
>
>> +     while ((data = fgetc(file)) != EOF) {
>
> Why are you using fgetc() rather than just fread() or read()?
>
No special reason. Code looks simpler I think than in case of using
fread() and feof() functions.

BR
Janusz

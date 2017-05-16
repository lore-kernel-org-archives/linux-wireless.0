Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33105 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753004AbdEPTqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 15:46:16 -0400
Received: by mail-yw0-f195.google.com with SMTP id 203so8599430ywe.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 12:46:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1fdab9d5-d8c6-88dc-38ac-2948e5fa74ec@rempel-privat.de>
References: <1fdab9d5-d8c6-88dc-38ac-2948e5fa74ec@rempel-privat.de>
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Tue, 16 May 2017 12:46:09 -0700
Message-ID: <CAMo8Bf+xbS46Kj4VP_+F2aZPZpOJ2UHV6WdHP_Ku_eaSQwm-7g@mail.gmail.com> (sfid-20170516_214656_217652_DEDFEF5C)
Subject: Re: Search for devices with Xtensa cores
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI Oleksij,

On Fri, Apr 28, 2017 at 11:23 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> this year started with inclusion of open-ath9k-htc-firmware to debian
> *main* repository. As first we started to getting advantage of regular
> compile tests. See results here:
> https://tests.reproducible-builds.org/debian/rb-pkg/unstable/i386/open-ath9k-htc-firmware.html
>
> Most of the problems which we currently get, are related to gcc xtensa
> compiler.
> In details: device specific patch set is used to provide our own
> gcc/binutils version because Xtensa don't really have defined CPU cores.
> As result, upstream compiler developers will never notice if some thing
> will brake this patch set.

Below are the links to the xtensa-dynconfig repository and xtensa-plugin-env
branches in binutils-gdb and gcc repositories. Together it is a draft
implementation of dynamically configurable xtensa toolchain.
Could you please take a look at it and see if it's useful for you?

https://github.com/jcmvbkbc/xtensa-dynconfig
https://github.com/jcmvbkbc/binutils-gdb-xtensa/commits/xtensa-plugin-env
https://github.com/jcmvbkbc/gcc-xtensa/commits/xtensa-plugin-env

-- 
Thanks.
-- Max

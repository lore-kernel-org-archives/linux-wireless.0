Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:46041 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeIDVLn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 17:11:43 -0400
Received: by mail-oi0-f53.google.com with SMTP id t68-v6so7949379oie.12
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 09:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <HE1PR0702MB3804CF0523876027EFB383FE980C0@HE1PR0702MB3804.eurprd07.prod.outlook.com>
References: <HE1PR0702MB38043B23810E618B01413959980F0@HE1PR0702MB3804.eurprd07.prod.outlook.com>
 <CALLGbRL+XDPk68LwBDoyVdibpNy314M81umexpUkHYn5TwA4RA@mail.gmail.com> <HE1PR0702MB3804CF0523876027EFB383FE980C0@HE1PR0702MB3804.eurprd07.prod.outlook.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 4 Sep 2018 13:45:47 -0300
Message-ID: <CAOMZO5AL36ejhygqYgmzz4=BuchgTjYgdTuFb9Qdich-BU74og@mail.gmail.com> (sfid-20180904_184551_755034_A6FC9070)
Subject: Re: Build iw for 32bit ARM
To: Jakov Simunic <jakov.simunic@ericsson.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Steve deRosier <derosier@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jakov,

On Mon, Sep 3, 2018 at 11:20 AM, Jakov Simunic
<jakov.simunic@ericsson.com> wrote:
> Hi Steve,
> We are building with ptxdist, we have a compiler for arm (arm-linux-gnuea=
bihf-gcc), I am not a total novice in this, and have already written some p=
txdist rules, but haven't done it with non-autoconfizzed packages, basicall=
y the problem is that if I use the default iw.make from the ptxdist master =
branch, iw's Makefile tries to compile with the native compiler and native =
libnl, no matter what option i supply it with, I always get a x86-32 execut=
able. When I modify the iw.make rule with the correct CC (by making a custo=
m compile step), it then fails to find the correct libnl through pkg-config=
. The iw package is not modified at all. Could you suggest how to hard code=
 the CC (or that it gets it normally from a CC variable supplied to the Mak=
efile) or how to avoid pkg-config and supply the options needed manually. I=
 know this is a step back from multi-platform build practices, but I just n=
eed it that way.

Maybe you can try to ask for help in the ptxdist mailing list.

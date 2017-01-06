Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36250 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968793AbdAFWkQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 17:40:16 -0500
MIME-Version: 1.0
In-Reply-To: <CACna6ryhvkSaHgU9igshnMjNg=wgeXd3p57VXxbr0ykoEtLH_g@mail.gmail.com>
References: <20170106152043.GA6383@rahul> <CACna6ryhvkSaHgU9igshnMjNg=wgeXd3p57VXxbr0ykoEtLH_g@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 6 Jan 2017 23:40:14 +0100
Message-ID: <CACna6ryFVOQbuAV+EzAFbG4E-rJ=vxmbV0eAZFnXkdyUyTf-7Q@mail.gmail.com> (sfid-20170106_234100_933846_EFDFF014)
Subject: Re: [PATCH] ssb: main.c: This patch removes unnecessary return
 statement using spatch tool
To: Rahul Krishnan <mrahul.krishnan@gmail.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 January 2017 at 23:39, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrot=
e:
> On 6 January 2017 at 16:20, Rahul Krishnan <mrahul.krishnan@gmail.com> wr=
ote:
>> This patch removes unnecessary return statement using spatch.
>> Signed-off-by: Rahul Krishnan <mrahul.krishnan@gmail.com>

Also an extra line break above Signed-off-by is preferred. Look at
"git log" to get am overview.

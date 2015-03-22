Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34925 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbbCVSfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:35:39 -0400
Received: by pdbop1 with SMTP id op1so163748363pdb.2
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2015 11:35:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427048376242.67051@mail.polimi.it>
References: <1427048376242.67051@mail.polimi.it>
Date: Sun, 22 Mar 2015 11:35:39 -0700
Message-ID: <CAMowtuMgAPsgAKuwSibjAzhDbqEdZGatikCiKks6f3w=4oth+Q@mail.gmail.com> (sfid-20150322_200417_212976_DB00C0A5)
Subject: Re: informations about Linux wifi driver's architecture today
From: Kathy Giori <kathy.giori@gmail.com>
To: Stefano Cappa <stefano.cappa@mail.polimi.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2015 at 11:19 AM, Stefano Cappa
<stefano.cappa@mail.polimi.it> wrote:
> Hi!
> some months ago, i saw the presentation of Johannes Berg in PDF, but now it isn't available, probably because it's very old.
>
> This slides will be updated to a new release?
>
> I have this slide and in page 5/35 (2009-02-26) there is the "Architecture - planned". This is the actual architecture or there are some differences in 2015? If yes, where i can find the new version of this page, with a little diagram?

Ciao Stefano,

Perhaps Johannes can post a current overview diagram on the Linux
wireless wiki (if you share with him which diagram you want to be
updated).

In terms of vendor-specific architecture, and how it fits in, Kalle
Valo posted a high-level diagram for ath10k:
https://wireless.wiki.kernel.org/en/users/drivers/ath10k/architecture

Are you mainly interested in the architecture of vendor-agnostic upper
layers or a description of a specific vendor driver?
kg

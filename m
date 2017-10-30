Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:44184 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932700AbdJ3Trf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 15:47:35 -0400
Received: by mail-io0-f193.google.com with SMTP id m16so29888236iod.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Oct 2017 12:47:35 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id q94sm6513143ioi.18.2017.10.30.12.47.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Oct 2017 12:47:33 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id 97so29875857iok.7
        for <linux-wireless@vger.kernel.org>; Mon, 30 Oct 2017 12:47:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b2af992abc624cdb8ae5a4c1d2d94090@SC-EXCH02.marvell.com>
References: <9370b3238604464b85bf0c4f8ac79c71@SC-EXCH02.marvell.com>
 <20171030170308.GA80479@google.com> <fb8d8eece601415c83167c500d80ff2f@SC-EXCH02.marvell.com>
 <20171030185043.GA100626@google.com> <b2af992abc624cdb8ae5a4c1d2d94090@SC-EXCH02.marvell.com>
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 30 Oct 2017 12:47:32 -0700
Message-ID: <CA+ASDXPXwW9OWpNreiE+3uoH5_w+tiZD4Yh9+oAO5Rb8cWb4iw@mail.gmail.com> (sfid-20171030_204738_776639_2FA2DE67)
Subject: Re: [EXT] Re: pull-request mwifiex-firmware 2017-10-30
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        James Cao <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 30, 2017 at 12:02 PM, Ganapathi Bhat <gbhat@marvell.com> wrote:
> Ok, prepared the follow up patch.  Let me also know if we can send a merge request while previous one is pending?
> If that is not the case I will send it as soon as the current request is merged.

That's not up to me. I'm sure the maintainer will let you know if they
need something, eventually. It's so trivial, I don't see why they
couldn't just pull it in without any more fuss.

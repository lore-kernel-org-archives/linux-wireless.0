Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33431 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932141AbdJYWDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 18:03:15 -0400
Date: Wed, 25 Oct 2017 15:03:13 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: David Ashley <dashxdr@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL usb adapter question
Message-ID: <20171025220313.GA4897@animalcreek.com> (sfid-20171026_000348_294404_CF561737)
References: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 25, 2017 at 01:43:55PM -0500, David Ashley wrote:
> I'm trying to understand how the linux kernel loads RTL8188CUS firmware
> rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
> when that file isn't available anywhere in my embedded system's filesystem.
> 
> Basically I'm trying to understand the theory. We have a product that
> is making use of the device

To get a general understanding of how fw loading works in Linux, read this:

https://www.kernel.org/doc/html/latest/driver-api/firmware/index.html

Mark
--

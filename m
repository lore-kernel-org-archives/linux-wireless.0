Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:56522 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdGQQSw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:18:52 -0400
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170716112129.10206-1-ian@mnementh.co.uk>
 <72fae7cb-7db0-4979-8e4b-cf26c557634a@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <cca7c921-3e3c-9e01-3515-dfd4b301ba17@mnementh.co.uk> (sfid-20170717_181855_691828_A687E9AB)
Date: Mon, 17 Jul 2017 17:18:50 +0100
MIME-Version: 1.0
In-Reply-To: <72fae7cb-7db0-4979-8e4b-cf26c557634a@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 13:41, Arend van Spriel wrote:
> For
> instance changing the order of parameters in a function is simply absurd
> although that is my opinion.

If one function has its parameters in a different order to all its
compatriots, I would consider this a highly likely scenario for someone
to mess up and use it incorrectly.

-Ian

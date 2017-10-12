Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:29518 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdJLS2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 14:28:05 -0400
Message-ID: <1507832866.5497.2.camel@intel.com> (sfid-20171012_202852_766692_A2A95FF7)
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the wireless-drivers tree
From: Luciano Coelho <luciano.coelho@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 12 Oct 2017 21:27:46 +0300
In-Reply-To: <20171012182114.fdeiv67ebx7c63te@sirena.co.uk>
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
         <1507832196.5497.1.camel@intel.com>
         <20171012182114.fdeiv67ebx7c63te@sirena.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-12 at 19:21 +0100, Mark Brown wrote:
> On Thu, Oct 12, 2017 at 09:16:36PM +0300, Luciano Coelho wrote:
> 
> > This is weird... The previous conflict was the exact opposite of
> > this. 
> > 44fd09 came in from wireless-drivers and dd05f9 came from wireless-
> > drivers-next.  I don't understand why it is saying the opposite
> > here...
> 
> I may have confused the trees when I was pasting things in, the
> commits
> are filled in by hand.

Ah, okay.  But still, if the same patches conflicted twice, why wasn't
there only one occurrence with both conflicts at once?

--
Luca.

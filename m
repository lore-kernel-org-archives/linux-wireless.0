Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaKEVgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:36:41 -0500
Date: Wed, 5 Nov 2014 13:36:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] staging: vt6655: mac remove dead variable
 TxRate_iwconfig
Message-ID: <20141105213641.GA13265@kroah.com> (sfid-20141105_223644_947288_96EB6877)
References: <CA+icZUXdHwiAKN1mzH15THTdMhwvozhmKoh-w9edpejBd2QZZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+icZUXdHwiAKN1mzH15THTdMhwvozhmKoh-w9edpejBd2QZZg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2014 at 10:17:59PM +0100, Sedat Dilek wrote:
> On Wed, Nov 5, 2014 at 10:08 PM, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> No need for "staging" in the subject line of your patches?

Why not?  It helps me sort emails better :)

thanks,

greg k-h

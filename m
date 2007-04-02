Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:52072 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648AbXDBQ5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 12:57:32 -0400
Date: Mon, 2 Apr 2007 18:56:43 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: Jouni Malinen <jkm@devicescape.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: SIOCSIWAP behavior question
Message-ID: <20070402165643.GH10005@thot.informatik.uni-kl.de>
References: <1175521655.9859.15.camel@localhost.localdomain> <20070402155405.GA2706@devicescape.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070402155405.GA2706@devicescape.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 02, 2007 at 08:54:05AM -0700, Jouni Malinen wrote:
> I would ike to see disconnect event only if the driver/stack notices
> that it cannot complete association and based on this, believes its
> association to the ESS is lost.

What is the recommended way to cause a disconnect / reconnect?

 Ciao
       Joerg
--
Joerg Mayer                                           <jmayer@loplof.de>
We are stuck with technology when what we really want is just stuff that
works. Some say that should read Microsoft instead of technology.


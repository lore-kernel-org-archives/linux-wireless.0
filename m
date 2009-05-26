Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37805 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZEZIA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 04:00:29 -0400
Date: Tue, 26 May 2009 09:57:01 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Galen P Zink <galen@zinkconsulting.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ralink Status
Message-ID: <20090526075700.GB3321@tuxdriver.com>
References: <C7F37A4E-95C1-4E89-9FE4-340F73900683@zinkconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C7F37A4E-95C1-4E89-9FE4-340F73900683@zinkconsulting.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 04:27:52PM -0700, Galen P Zink wrote:
> Ralink has released open source drivers for their 2800-series cards. I  
> presume they are GPL, given how closely they're tied to the kernel. Is  
> there any reasons these aren't coming into the linux tree?

You must be new... :-)

Those drivers are not properly integrated with existing kernel
infrastructure.  The rt2x00 team is working on support for that
hardware, using those drivers as a reference where appropriate.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

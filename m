Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:33799 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbYFZA1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 20:27:05 -0400
Date: Thu, 26 Jun 2008 01:26:45 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id	0x8197/0x8189
Message-ID: <20080626002645.GB2618@srcf.ucam.org> (sfid-20080626_022819_034275_90FA8D7D)
References: <922158.32180.qm@web23114.mail.ird.yahoo.com> <20080625140809.GA9111@tuxdriver.com> <48625D39.30700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48625D39.30700@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 25, 2008 at 09:59:05AM -0500, Larry Finger wrote:

> Would you like me to send the updated version to you, or should I send 
> it to linux-wireless and John?

One thing I noticed is that the 0x8187 USB ID seems to be used for both 
plain and b devices, so I suspect we're going to need some more 
intelligent probing than just basing it off USB ID. IIRC, the endpoint 
descriptions are different?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

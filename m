Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:40418 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0BLStP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 13:49:15 -0500
Message-ID: <4B75A271.7010705@csr.com>
Date: Fri, 12 Feb 2010 18:48:17 +0000
From: David Vrabel <david.vrabel@csr.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Dan Tian <Dan.Tian@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
Subject: Re: Coordinating development for Bluetooth 3.0 between 802.11 and
 BT trees
References: <43e72e891002111210l55d6a802pc5a1384e3535c845@mail.gmail.com> <20100212183309.GB4983@tuxdriver.com>
In-Reply-To: <20100212183309.GB4983@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> In any case, I was under the impression that at least the initial
> parts of the 802.11 AMP implementation could happen independently
> from any bluetooth stack changes...?

You should be able to do (almost) all of the AMP PAL development and
testing without a Bluetooth stack.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom

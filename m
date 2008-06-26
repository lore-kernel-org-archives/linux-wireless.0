Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48268 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYFZVPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:15:31 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product =?iso-8859-1?q?id=090x8197/0x8189?=
Date: Thu, 26 Jun 2008 18:15:33 -0300
Cc: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>,
	Pavel Roskin <proski@gnu.org>,
	Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	andreamrl@tiscali.it, linville@redhat.com
References: <779389.39286.qm@web23108.mail.ird.yahoo.com> <4863F1DE.3080503@yahoo.co.uk> <4863FFBB.9020504@lwfinger.net>
In-Reply-To: <4863FFBB.9020504@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806261815.34342.herton@mandriva.com.br> (sfid-20080626_231534_950482_7EAD4CF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thursday 26 June 2008 17:44:43 Larry Finger escreveu:
> Hin-Tak Leung wrote:
<snip>
> 
> > Herton's code also seem to distinguish revC/revD/revE of different 
> > 8187B's -
> > I don't seem to have seen those distinctions in the original vendor 
> > code, but
> > maybe I haven't look hard enough :-).
> 
> I have not found them either. FWIW, my device is reported as 
> RTL8187BvE V0 + rtl8225z2. The decision comes from 
> rtl818x_ioread8(priv, (u8 *)0xFFE1), but I don't know what is at that 
> address.

In the vendor driver this is commented as being the 8187B hardware version
register (it's a raw value address used in the code with a comment). I should
have commented the line as something like "read 8187b hardware version
register", or may be add a field to struct rtl818x_csr. One more thing to add
to the patch. In fact I would like to have a datasheet or ask to someone that
has to confirm this.

> 
> Larry
> 

--
[]'s
Herton

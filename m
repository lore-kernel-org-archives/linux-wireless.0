Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:61991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318AbZLFWWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 17:22:52 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
Date: Sun, 6 Dec 2009 20:22:57 -0200
Message-ID: <be7a9f3d0912061422x5a0fd2f6ubd7add33472a8136@mail.gmail.com>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
From: Otavio Salvador <otavio@ossystems.com.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Alan,

On Sun, Dec 6, 2009 at 8:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> When I use 2.6.32 (or indeed 2.6.32-rc1), it works fine up until the
> point where the wireless card is ifconfig'ed.  Then not long afterward
> (a few seconds to a minute) the system hangs.

Did you test it with 2.6.32? Since 2.6.32-rc1 many fixes has been done
into kernel and would be nice if you could test against current
kernel.

Cheers,

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44163 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab2LCOYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 09:24:33 -0500
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: [PATCH V2 v3.7] brcmsmac: handle packet drop on enqueuing correctly
References: <1353961396-7061-1-git-send-email-arend@broadcom.com>
	<50BC63E5.9020101@broadcom.com>
Date: Mon, 03 Dec 2012 16:24:31 +0200
In-Reply-To: <50BC63E5.9020101@broadcom.com> (Arend van Spriel's message of
	"Mon, 3 Dec 2012 09:33:41 +0100")
Message-ID: <871uf7w6w0.fsf@purkki.adurom.net> (sfid-20121203_152437_153239_77288971)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

"Arend van Spriel" <arend@broadcom.com> writes:

> What is keeping you from picking up this patch? Anything I should do?
> This V2 removed the no-op changes in ampdu.c that Seth indicated so...

Most likely it's too late. Dave already told that that John's previous
pull request might not make it to 3.7.

-- 
Kalle Valo

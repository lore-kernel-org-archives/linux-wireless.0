Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37744 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1HXR44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 13:56:56 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: HT-PHY: init: add missing small-tables writes
References: <1313250844-4526-1-git-send-email-zajec5@gmail.com>
	<CACna6rwoyPuwnzcw4BR5dmOiX9ogsTbquaG6qwRMZtLZytNnoA@mail.gmail.com>
	<20110823134932.GB9770@tuxdriver.com>
	<1314118360.21805.126.camel@shinybook.infradead.org>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 24 Aug 2011 20:56:52 +0300
In-Reply-To: <1314118360.21805.126.camel@shinybook.infradead.org> (David Woodhouse's message of "Tue\, 23 Aug 2011 17\:52\:38 +0100")
Message-ID: <87pqjuofq3.fsf@purkki.adurom.net> (sfid-20110824_195705_995534_3F33C5AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse <dwmw2@infradead.org> writes:

> On Tue, 2011-08-23 at 09:49 -0400, John W. Linville wrote:
>> Please, _please_, _PLEASE_ stop doing this.  I process a lot of
>> patches, and sometimes I will miss these directives.
>
> Best just to publish a git tree which John can pull in to
> wireless-testing.git, much as trees get pulled to linux-next.
>
> That way it'll *always* have the patches you want, in the order you
> want.

That's true, but setting up git tree for wireless is not trivial and
not for the faint of heart. Especially due to differences between
wireless-next and wireless-testing. Sending a patch series is a lot
easier and causes less tears.

-- 
Kalle Valo

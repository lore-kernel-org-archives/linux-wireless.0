Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:28658 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYAOKNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 05:13:33 -0500
To: David Woodhouse <dwmw2@infradead.org>
Cc: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge errors on 'everything'
References: <200801091043.02204.bruno@thinktube.com>
	<20080109015102.GB3048@tuxdriver.com> <1199845968.3697.22.camel@dv>
	<87myrf74ix.fsf@nokia.com>
	<1200229852.2647.4.camel@shinybook.infradead.org>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 15 Jan 2008 12:11:40 +0200
In-Reply-To: <1200229852.2647.4.camel@shinybook.infradead.org> (ext David Woodhouse's message of "Sun\, 13 Jan 2008 13\:10\:52 +0000")
Message-ID: <873aszv1nn.fsf@nokia.com> (sfid-20080115_101338_733638_83D1054E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse <dwmw2@infradead.org> writes:

>> It would be nice if git would somehow do this automatically with
>> rebased trees. Or maybe it already supports it and I'm not just aware
>> of it?
>
> Why would it? Git isn't designed to handle rebasing nicely -- rebasing
> is something that should only ever happen if you screw up and have to
> start again.

Maybe in theory, but in practise maintainers rebase a lot. And I, as a
git user, have to deal with that and do git reset trickery etc.

-- 
Kalle Valo

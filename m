Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:34741 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756496Ab0BQVOx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 16:14:53 -0500
Message-ID: <151167.60599.qm@web23106.mail.ird.yahoo.com>
Date: Wed, 17 Feb 2010 21:14:52 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
To: okias <d.okias@gmail.com>, sedat.dilek@gmail.com
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	herton@mandriva.com.br
In-Reply-To: <2d0a357f1002171113n7ceb8fbdr2f54c17699151949@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 17/2/10, Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> You could be more precise on the
> commit-subject (not blaming you) next time.
> Worth reading on this topic: "On Commit Messages" [1].

Ditto. Here is the definitive recommended reading for submitting patches.
BTW, you also missed a Signed-off line.

http://linuxwireless.org/en/developers/Documentation/SubmittingPatches/sourcedoc

I think normally the v1/v2/v3 part goes into the front, e.g.
[PATCH v1] ...

Things like 'ok, sorry I tested...' should probably be in a reply to your own post, or preferably, not - you either put it in the commit message itself, or leave it out.
That's because John accepts about 40 patches per day, and git provides the facility to automatically extract patches per e-mail (for all e-mails filed into a folder, for example) - anything that requires manual editing to remove is considered undesirable. Same with the ambiguous subject line, and v3, etc. About 600(?) patches goes into each kernel releases - if ever patch comes in as 'minor clean up', 'fix one bug', 'fix intermittent crash', 'tried n times now' for the patch summary, nobody would know what goes into the kernel. :-). 



      

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbbENBfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 21:35:17 -0400
Date: Thu, 14 May 2015 03:35:12 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ming.lei@canonical.com, Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dhowells@redhat.com, Seth Forshee <seth.forshee@canonical.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	pebolle@tiscali.nl,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>, casey@schaufler-ca.com,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle McMartin <kyle@kernel.org>
Subject: Re: [RFC v2 6/6] firmware: add firmware signature checking support
Message-ID: <20150514013512.GS23057@wotan.suse.de> (sfid-20150514_033538_476800_A2C34C35)
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
 <1431541436-17007-7-git-send-email-mcgrof@do-not-panic.com>
 <CAGRGNgW3+SgOqt-env6SBp+j7S4wQcXTK0HpuiM_BYbLzpfohA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgW3+SgOqt-env6SBp+j7S4wQcXTK0HpuiM_BYbLzpfohA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2015 at 10:31:52AM +1000, Julian Calaby wrote:
> On Thu, May 14, 2015 at 4:23 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > +"Require all firmware to be validly signed", under the same menu.
> 
> You reference the relevant Kconfig symbols above, do you want to add
> it here too?

Sure, amended, thanks.

 Luis

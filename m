Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:33234 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751302AbcA3HY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 02:24:57 -0500
Message-ID: <1454138693.3524.1.camel@perches.com> (sfid-20160130_082527_349101_EB3C6B88)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
From: Joe Perches <joe@perches.com>
To: Bhakti Priya <bhaktipriya96@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 29 Jan 2016 23:24:53 -0800
In-Reply-To: <CAFNHFT9nosMWgAvDdhvpMQLa2+02kD-wk0ChuZWpvCbLGMFYOg@mail.gmail.com>
References: <20160129172908.GA14077@Karyakshetra>
	 <wrfjk2ms465z.fsf@redhat.com>
	 <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
	 <1454117303.10099.84.camel@perches.com>
	 <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com>
	 <1454123891.10099.89.camel@perches.com>
	 <CAFNHFT9nosMWgAvDdhvpMQLa2+02kD-wk0ChuZWpvCbLGMFYOg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-01-30 at 12:23 +0530, Bhakti Priya wrote:
> I will be happy to extend checkpatch.pl. As suggested by you, I am
> trying to detect such blank lines in a line removal patch by checking
> if the line above the deleted line was a blank line and the line
> following the deleted line had a closing brace.
> Can you please guide me and let me know if I am headed in the right
> direction.

You have to track all the + and - lines that precede the
deleted line.

Good luck.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm25-vm0.bullet.mail.ird.yahoo.com ([212.82.109.201]:46232 "HELO
	nm25-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752748Ab2BWAou convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 19:44:50 -0500
Message-ID: <1329957888.76143.YahooMailClassic@web29502.mail.ird.yahoo.com> (sfid-20120223_014453_865365_B626D35D)
Date: Thu, 23 Feb 2012 00:44:48 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Attila Fazekas <turul64@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <4F457BCD.5020200@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 22/2/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:

<snipped bits>
> > As Larry requested - please send the patch without
> munching from your
> > e-mail client. Since you are on gmail, I could offer a
> little advice on git-send-email, which may or may not be
> something you already know. This is what I do to send
> patches from my gmail account (change "name" and "acct" and
> "FILLTHISIN" and "patch-file" to suit yourself), and you
> could add --cc a few of us there also:
> >
> > git send-email --from 'name<acct@gmail.com>'
> \
> > --to linux-wireless@vger.kernel.org
> --to linville@tuxdriver.com
> \
> > --smtp-server smtp.gmail.com --smtp-server-port 465
> --smtp-user \ acct@gmail.com
> --smtp-pass FILLTHISIN --smtp-ssl patch-file
> >
> > You can do "man git-send-email" (all git man pages uses
> "git-something" to document the "git something" sub
> commands, with a dash between) to read about all the
> switches and what they are supposed to do.
<snipped>

> I fixed and tested your patch. With it, I certainly see the
> beacons and I was 
> able to use NetworkManager to connect once. However, I was
> never able to ping 
> from either end of the network to the other.

Do you need something manual set-up like "ifconfig wlan1 192.168.0.1" for one box and "ifconfig wlan1 192.168.0.2" for the other box in the IP layer to work? I haven't quite got my head around this one - how network manager agrees for each for go into a private tcp/ip network, given there are three(?) private ranges to use, and setting up host names, and what ip adresses to assign... and since there is no dns for a network of two, it would have to ping by ip address?

> Besides the mangling of the patch by your mailer, you had
> many problems with 
> spaces instead of tabs. Did you use scripts/checkpatch.pl to
> test for errors?

Hmm, probably try not to scare him away... Here is the definitive guide from Linus for submitting patches for the kernel in general:

http://linuxwireless.org/en/developers/Documentation/SubmittingPatches/sourcedoc

and here is one with information specific to wireless stuff:

http://linuxwireless.org/en/developers/Documentation/SubmittingPatches


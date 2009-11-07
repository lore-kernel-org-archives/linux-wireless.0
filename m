Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52376 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZKGNpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 08:45:07 -0500
Date: Sat, 7 Nov 2009 08:43:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: =?iso-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Changing from Minstrel to PID
Message-ID: <20091107134330.GB25893@tuxdriver.com>
References: <1257542956.6565.2.camel@localhost.localdomain> <20091106214803.GL2782@tuxdriver.com> <1257545606.3752.2.camel@localhost.localdomain> <b6c5339f0911061424l33178e81k16fb1f3889edcc3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b6c5339f0911061424l33178e81k16fb1f3889edcc3c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2009 at 05:24:47PM -0500, Bob Copeland wrote:
> On Fri, Nov 6, 2009 at 5:13 PM, Martín Ernesto Barreyro
> <barreyromartin@gmail.com> wrote:
> >> No, but I wish there were...patches?  Anyone?
> >
> > Sorry for my ignorance, but how could I send a parameter to a module or
> > use a configuration file? could be with sysctl?
> 
> You do have to compile them both, but once you do, if you
> have debugfs mounted, you can do:
> 
> echo 'pid' > /debug/ieee80211/phy0/rc/name
> 
> to switch to pid.

Does that work?  I thought that was only informational (and readonly)?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

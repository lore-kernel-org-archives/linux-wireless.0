Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:42880 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754346AbbETQ34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 12:29:56 -0400
Date: Wed, 20 May 2015 18:49:25 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520154925.GA10473@localhost> (sfid-20150520_183000_284540_3B7E793A)
References: <20150519200232.GM23057@wotan.suse.de>
 <1432072117.4510.180.camel@linux.vnet.ibm.com>
 <20150519221902.GQ23057@wotan.suse.de>
 <1432078625.4510.207.camel@linux.vnet.ibm.com>
 <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com>
 <1432084019.4510.242.camel@linux.vnet.ibm.com>
 <CALCETrU_Jw0diMneXo8+OQTwp4=Ta3NbU2jYapkipimxMCWgjw@mail.gmail.com>
 <1432087551.4510.260.camel@linux.vnet.ibm.com>
 <CALCETrWu7MxxtKHYmbsKwKdMey=YWVn42rYJ+YfkiVuwo55jKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALCETrWu7MxxtKHYmbsKwKdMey=YWVn42rYJ+YfkiVuwo55jKQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-19 19:10:07, Andy Lutomirski wrote:
> On Tue, May 19, 2015 at 7:05 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > Perhaps you're referring to EVM?
> 
> I don't know.  I also couldn't figure out what IMA was and what EVM was.

Try reading this:

http://sourceforge.net/p/linux-ima/wiki/Home/

A little outdated with some bits missing, but definitely worth reading.  It will 
also help lower the noise in LSM mailing list. :)


		Petko

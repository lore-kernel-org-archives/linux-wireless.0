Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39931 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2EBPrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 11:47:51 -0400
Date: Wed, 2 May 2012 11:39:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	Antonio Quartulli <ordex@autistici.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120502153914.GA9285@tuxdriver.com> (sfid-20120502_174757_091653_549DBA53)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
 <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
> On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> <meenakshi.venkataraman@intel.com> wrote:
> > Hi Antonio,
> >
> >>> it seems so. It happens at least once at boot time.
> >>> I will try wireless-testing and see what happens. Then I will apply your patch.
> >>
> >>The problem is there either with wireless-testing and with
> >>wireless-testing+your_patch.
> >>
> >>If it can somehow help, I also got several stack trace regarding intel_iova
> >>functions. But then the I got kernel panic and I was not able to copy the
> >>messages.
> >
> > [MV] Depending on how you set it up, perhaps the stack trace was saved in one of the syslog files in /var/log/...
> >
> > Thanks!
> > Meenakshi
> >
> 
> Can you please re-run with debug=1 and send the whole log ?
> This will give a better indication on when the issue occurs.

Does this help?

	https://bugzilla.redhat.com/show_bug.cgi?id=815998#c18

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

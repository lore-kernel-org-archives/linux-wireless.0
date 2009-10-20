Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbZJTR2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 13:28:32 -0400
Subject: Re: 'linux-wireless@vger.kernel.org'
From: reinette chatre <reinette.chatre@intel.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
	"Kristofik, Juraj" <Juraj.Kristofik@teradata.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <3ace41890910200345i7ca796b2s9b26a6f465d066db@mail.gmail.com>
References: <717B3566C64F54459B25922289704B8E6DF4D5@susday7667.TD.teradata.com>
	 <2d0a357f0910200334g7cdacb2bh351f20f3afa3932c@mail.gmail.com>
	 <3ace41890910200345i7ca796b2s9b26a6f465d066db@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 10:28:32 -0700
Message-Id: <1256059712.21134.1411.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-10-20 at 03:45 -0700, Hin-Tak Leung wrote:

> Error 17 is "File Exists" apparently - I am not the author of the said
> relevant code, and I am just writing of my understanding of it -
> Feel free to have a go yourself - it is at net/mac80211/main.c .
> 

This problem showed up before when a user was testing from
compat-wireless. Moving to wireless-testing resolved the issue. The
thread is at
http://thread.gmane.org/gmane.linux.kernel.wireless.general/35983

Reinette


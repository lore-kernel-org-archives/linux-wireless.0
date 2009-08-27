Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:48338 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZH0Qu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 12:50:56 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu\, Yi" <yi.zhu@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: show_version() displays confusing/wrong firmware version
References: <1251379989-20728-1-git-send-email-bjorn@mork.no>
	<1251385041.3805.17.camel@rc-desk> <87r5uxb8fi.fsf@nemi.mork.no>
	<1251386952.3805.23.camel@rc-desk>
Date: Thu, 27 Aug 2009 18:50:52 +0200
In-Reply-To: <1251386952.3805.23.camel@rc-desk> (reinette chatre's message of
	"Thu, 27 Aug 2009 08:29:12 -0700")
Message-ID: <87d46hb3pv.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> Since 2.6.31 is considered a done deal and this is surely not the
> required "earth shattering" fix (see [1]) I cannot push this as a fix
> into Linus's repo at this time. This display problem will not exist in
> 2.6.32.

Ah, I see. Yes, that looks even better.  I feel a bit stupid for not
checking iwlwifi-2.6.git before sending this.  Thanks for your patience.


Bjørn

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:10646 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYGNSSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 14:18:48 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1541094nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 11:18:47 -0700 (PDT)
Message-ID: <f6ca9fed0807141118w10d9817n5c9a47cf0a9f8ca@mail.gmail.com> (sfid-20080714_201852_140945_27E3966D)
Date: Mon, 14 Jul 2008 20:18:46 +0200
From: drago01 <drago01@gmail.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 random firmware crashes
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF0017469B4@orsmsx413.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com>
	 <4220499A1B034C4FA93B547BA01E1FF0017469B4@orsmsx413.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 8:05 PM, Cahill, Ben M <ben.m.cahill@intel.com> wrote:
> Try loading driver using module param:
>
> debug=0x43fff
>
> This will provide more information in the log, including an event log
> (where you see "Microcode SW Error detected" in your log, you would have
> captured Event Log if you had the debug=0x43fff setting).

will try to capture the event log when it happens again.

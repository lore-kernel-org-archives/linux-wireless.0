Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:56211 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYGNSLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 14:11:19 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1493912yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 11:11:19 -0700 (PDT)
Message-ID: <69e28c910807141111l5af660e7l5e407a7b94a5cb79@mail.gmail.com> (sfid-20080714_201123_252733_A18334B4)
Date: Mon, 14 Jul 2008 20:11:18 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 random firmware crashes
Cc: drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
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
>
> -- Ben --

Just a question: Why are we using cryptic hex IDs for the debug
setting? Is there a specific reason for this, or just noone has yet
included proper modparams for the various debugging settings?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

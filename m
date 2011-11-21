Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab1KUHmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 02:42:44 -0500
Date: Mon, 21 Nov 2011 08:44:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 45/77] iwlegacy: s/rx_reply/hdl/
Message-ID: <20111121074432.GA2787@redhat.com> (sfid-20111121_084251_206117_EEF71360)
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
 <1321604559-10707-45-git-send-email-sgruszka@redhat.com>
 <20111118180208.6a16e68c@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111118180208.6a16e68c@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 06:02:08PM -0500, Pavel Roskin wrote:
> Why do you want it?  
For the same reason as in other patches - for make code shorter. 

>I understand rx_reply, 
Actually rx_reply is confusing name for interrupt handler.

> but I don't understand
> "hdl".  Is it Hairy Definition Language? :)
:-) it's shortcut from "handler", but you known it, don't you ?

Stanislaw

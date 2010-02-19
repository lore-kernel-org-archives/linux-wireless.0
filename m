Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41477 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0BSOQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 09:16:14 -0500
Received: by bwz1 with SMTP id 1so80383bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 06:16:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
Date: Fri, 19 Feb 2010 15:16:11 +0100
Message-ID: <22ee4e771002190616h72949c58n72e2e6a49f7ae1d3@mail.gmail.com>
Subject: Re: FYI: needlessly exported symbols
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 10:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> According to a little analysis I did on wireless-testing, these symbols
> need not be exported because they're not imported by any module:
>
> p54_parse_eeprom

p54spi(.ko) needs p54_parse_eeprom from p54common(.ko)

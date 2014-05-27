Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:55513 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752487AbaE0OPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:15:11 -0400
Message-ID: <1401200106.20587.0.camel@joe-AO725> (sfid-20140527_161518_601636_E739CF69)
Subject: Re: [PATCH 4/7] wil6210: improve debug for WMI receive
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Tue, 27 May 2014 07:15:06 -0700
In-Reply-To: <1835954.xHumgOahYl@lx-wigig-72>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1401191150-29037-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1401199199.18413.26.camel@joe-AO725> <1835954.xHumgOahYl@lx-wigig-72>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-27 at 17:11 +0300, Vladimir Kondratiev wrote:
> On Tuesday, May 27, 2014 06:59:59 AM Joe Perches wrote:
> > This error message might be expanded a bit to describe
> > a bit more about what to do: report to you, turn on
> > event debugging, update firmware, etc...
> 
> As of now, for the user it is nothing to do;
> I expect to see this messages in the bug reports that
> may be potentially sent to me. It may help understanding
> the situation. But, again, this message itself do not
> indicate anything interesting.

Then is it an error?
Maybe use dev_notice instead.




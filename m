Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39780 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756334AbXIXTjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:39:47 -0400
Message-ID: <46F81281.7080407@lwfinger.net>
Date: Mon, 24 Sep 2007 14:39:45 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Guide on how to submit patches for linux-wireless
References: <43e72e890709241209obc236eav5eca6c0828052ee1@mail.gmail.com>
In-Reply-To: <43e72e890709241209obc236eav5eca6c0828052ee1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Here's a new guide to help developers write and submit patches
> specifically for linux-wireless:
> 
> http://linuxwireless.org/en/developers/SubmittingPatches
> 

Very useful contribution. I have only two comments: (1) The pop-up above developers needs to be
taller. The entry for 'Testing' overwrites the Developers tab on my machine, and (2) patches,
particularly large ones, need to be run through scripts/checkpatch.pl. It is better to find the
"errors" yourself than have Andrew or Jeff point them out publicly.

Larry

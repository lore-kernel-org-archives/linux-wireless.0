Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63502 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2G0VOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 17:14:12 -0400
Received: by weyx8 with SMTP id x8so2355865wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 14:14:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Lopez <jlopex@cozybit.com>
Subject: Re: [PATCH v2] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
Date: Fri, 27 Jul 2012 23:14:05 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1343413645-4088-1-git-send-email-jlopex@cozybit.com>
In-Reply-To: <1343413645-4088-1-git-send-email-jlopex@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201207272314.05817.chunkeey@googlemail.com> (sfid-20120727_231450_727263_19EA65A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2012 20:27:25 Javier Lopez wrote:
> This patch contains following modifications:
> 
> - Add mesh capabilities on fw.c to permit creation of mesh
>   interfaces using this driver.
> 
> - Modify carl9170_set_operating_mode, to use AP-style beaconing
>   with mesh interfaces.
> 
> - Allow beacon updates for NL80211_IFTYPE_MESH_POINT type in
>   carl9170_handle_command_response.
> 
> - Add NL80211_IFTYPE_MESH_POINT case on carl9170_op_add_interfaces to
>   support mesh/ap/sta virtual interface combinations.
> 
> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

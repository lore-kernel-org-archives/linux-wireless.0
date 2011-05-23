Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39156 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab1EWLjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 07:39:35 -0400
Received: by fxm16 with SMTP id 16so3771277fxm.9
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 04:39:32 -0700 (PDT)
Date: Mon, 23 May 2011 14:39:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: TX status report missed for queue %d entry %d
Message-ID: <20110523113855.GD2175@legolas.emea.dhcp.ti.com> (sfid-20110523_133940_392112_9561D6B7)
Reply-To: balbi@ti.com
References: <20110523113701.GC2175@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
In-Reply-To: <20110523113701.GC2175@legolas.emea.dhcp.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

+ linux-wireless

On Mon, May 23, 2011 at 02:37:01PM +0300, Felipe Balbi wrote:
> using 2.6.39, RaLink is really really slow and sometimes my mutt gets
> stuck waiting forever for something. Same goes with irssi, it even
> disconnects or gets a really high Lag (have seen over 90!).
>=20
> dmesg follows below:
>=20
> fo - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 4285.045897] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - =
CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 4285.047519] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - =
CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 4285.048768] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - =
CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 4285.073751] cfg80211: Calling CRDA to update world regulatory domain
> [ 4287.618257] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4289.654723] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4289.662816] wlan1: authenticate with 10:9a:dd:89:4c:83 (try 1)
> [ 4289.664844] wlan1: authenticated
> [ 4291.259924] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4291.264555] wlan1: associate with 10:9a:dd:89:4c:83 (try 1)
> [ 4291.271315] wlan1: RX AssocResp from 10:9a:dd:89:4c:83 (capab=3D0x431 =
status=3D0 aid=3D2)
> [ 4291.271318] wlan1: associated
> [ 4291.271411] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - =
CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 4291.272789] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - =
CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 4291.274285] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - =
CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 4291.275785] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - =
CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 4297.227281] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4297.227287] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4297.253506] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4297.281917] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4297.310340] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4297.316264] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4297.321869] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4297.321876] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4297.362423] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4297.369293] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4297.579175] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4297.617106] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4298.377421] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4298.377430] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4298.379164] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4300.456586] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4300.492201] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4300.495144] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4304.810539] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4304.850888] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4304.852966] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4304.856002] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4305.033587] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4305.703029] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4308.758400] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4309.736046] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4311.312787] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4311.313995] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4312.373921] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4312.373930] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4312.563593] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4313.304329] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4313.932611] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4313.932620] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4314.312033] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4314.833841] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4315.076643] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4315.562427] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4316.172830] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4316.725545] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4316.874621] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4316.876281] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4317.270107] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4317.358205] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4317.843638] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4318.560880] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4318.995633] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4319.870500] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4319.878486] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4320.661092] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4321.294670] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4321.804620] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4321.926704] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4323.295102] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4324.558248] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4324.671427] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4324.805866] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4324.857889] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4324.857899] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4325.052817] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4325.868020] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4325.895236] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4326.090652] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4326.090660] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4326.313328] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4326.313336] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4326.566464] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4326.797171] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4326.987231] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4327.429344] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4327.561118] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4328.255698] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4328.259788] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4328.291980] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4328.829435] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4329.007164] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4329.010312] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4330.052684] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4330.085640] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4330.278706] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4334.796522] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4334.834458] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4334.835826] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4334.874139] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4334.878503] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4334.882249] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4334.909455] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4334.919468] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4334.921679] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4334.944020] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4334.953501] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4335.387457] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4335.387750] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4336.569325] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4336.606405] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4336.607274] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4336.607521] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4336.639644] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4336.641717] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4336.645332] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4336.673370] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4336.679649] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4336.707608] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4336.712469] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4336.741108] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4336.749658] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4336.777172] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4336.783477] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4336.791023] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4336.791030] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4336.811302] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4336.819410] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4336.821528] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4337.447781] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4337.483391] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4337.484008] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4337.518336] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4337.521697] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4337.527815] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4337.527821] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4337.554849] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4337.563502] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4337.567743] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4337.569361] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4337.606674] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4337.609417] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4337.642119] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4337.647983] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4337.647990] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4337.650598] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4337.669696] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4337.687417] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4337.795962] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4337.795971] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4338.454047] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4338.805612] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4339.134046] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4339.148396] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4339.516387] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4340.304404] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4340.941932] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4341.303058] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4341.376929] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4349.183975] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4349.183980] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4349.184217] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4349.185467] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4351.886688] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4352.064261] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4352.106312] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4353.189195] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4353.195308] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4353.201420] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4353.218891] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4353.223382] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4353.232993] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4353.240604] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4353.245842] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4353.253582] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4353.261192] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4353.267431] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4353.275544] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4353.283077] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4353.290395] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4353.296509] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4353.302624] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4353.302630] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4357.556777] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4357.724750] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4357.737855] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4357.758068] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4357.788641] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4357.805738] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4357.829447] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4357.852406] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4357.864013] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4357.864019] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4358.024859] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4358.042953] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4358.060295] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4358.074774] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4358.094694] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4358.106970] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4358.113329] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4358.113335] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4358.382616] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4358.382862] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4360.937337] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4369.870996] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4371.759703] phy0 -> rt2x00queue_flush_queue: Warning - Queue 2 failed =
to flush
> [ 4371.776155] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4371.776403] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4373.644417] phy0 -> rt2x00queue_flush_queue: Warning - Queue 2 failed =
to flush
> [ 4373.692725] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4375.589025] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4375.605801] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4375.755672] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4375.755677] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4384.617896] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4384.617902] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4384.753651] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4384.753660] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4384.754160] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4385.043162] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4385.384283] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4385.581896] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4388.918236] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4388.918245] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4395.022090] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4406.756063] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4408.260393] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4409.258529] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4433.266791] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4433.266796] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4433.483916] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4433.483925] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4433.702049] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4433.702058] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4433.923585] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4433.923595] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4434.170474] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4440.482746] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4440.484595] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4441.946454] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4442.098944] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4442.098953] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4442.133614] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4444.650130] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4447.655615] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4447.850732] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4448.462091] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4448.813726] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4448.865903] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4448.900862] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4448.945027] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4448.956125] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4448.986572] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4449.059696] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4449.059703] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4449.130698] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4449.154904] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4449.155652] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4449.176117] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4449.200828] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4449.400238] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4449.542220] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4449.775961] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4449.811151] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4450.416354] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4450.448177] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4450.480247] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4450.510566] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4450.543634] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4450.579825] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4450.613266] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4450.627246] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4450.647086] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4450.681275] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4450.715466] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4450.747036] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4451.233076] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4451.233085] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4451.485638] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4451.948221] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4451.985527] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4453.203681] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4453.247868] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4453.248221] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4454.827252] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4454.999336] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4455.008195] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4455.012684] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4455.018427] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4455.032651] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4455.033772] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4455.040263] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4455.049043] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4455.056984] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4455.077200] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4455.079199] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4455.087301] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4455.096666] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4455.102774] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4455.110261] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4455.110638] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4459.826514] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4459.994222] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4460.015932] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4460.030658] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4460.065225] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4460.086189] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4460.099042] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4460.112270] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4460.141221] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4460.141230] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4460.395778] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4460.408509] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4460.428349] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4460.456553] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4460.472900] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4463.164491] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4464.162646] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4477.140042] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4488.931108] phy0 -> rt2x00queue_flush_queue: Warning - Queue 2 failed =
to flush
> [ 4491.566508] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4494.529517] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4494.529522] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4494.565492] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4495.556758] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4495.586633] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4495.586640] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4495.596863] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4495.600471] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4495.602841] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4495.605847] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4495.607465] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4495.609033] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4495.612949] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4495.614696] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4495.633164] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4495.634786] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4495.637156] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4495.641774] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4495.644519] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4495.646266] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4495.647764] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4495.650384] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4495.656001] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4495.656624] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4495.670102] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4495.671723] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4495.673219] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4495.675716] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4495.677339] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4495.682580] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4495.683950] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4495.685698] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4495.687324] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4495.688941] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4495.690565] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4495.692345] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4495.694682] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4495.708538] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4495.709657] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4495.711284] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4495.715279] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4495.716771] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4495.718393] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4495.719765] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4495.721261] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4495.723008] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4495.724323] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4495.725754] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4495.727376] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4495.729376] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4495.731130] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4495.732616] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4495.734240] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4495.742357] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4495.744381] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4495.746969] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4495.750338] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4495.751598] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4495.752834] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4495.754205] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4495.755704] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4495.757201] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4495.758571] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4495.762568] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4495.764938] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4495.765436] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4495.767057] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4495.768430] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4495.770051] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4495.771802] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4495.773174] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4495.774673] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4495.776168] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4495.778538] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4495.864397] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4495.969963] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4497.723316] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4500.876241] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4501.243252] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4502.939947] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4503.000223] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4505.533101] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4507.311417] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4507.773873] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4507.777602] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4507.780358] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4507.780362] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4507.784727] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4507.787843] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4507.787850] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4507.791085] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4507.793461] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4507.863091] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4507.863106] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4510.720166] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4516.662796] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4516.676022] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4516.676028] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4517.757786] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4520.703827] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4521.669924] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4521.669940] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4522.660707] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4522.748180] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4522.750427] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4522.752295] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4523.130648] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4526.126321] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4526.223817] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4526.663563] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4528.660377] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4528.840686] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4530.685754] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4531.658659] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4531.658674] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4532.131885] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4533.665243] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4533.835806] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4533.835818] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4534.285035] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0008
> [ 4534.285244] hub 2-1:1.0: port 3, status 0101, change 0001, 12 Mb/s
> [ 4534.411661] hub 2-1:1.0: debounce: port 3: total 100ms stable 100ms st=
atus 0x101
> [ 4534.483541] usb 2-1.3: new high speed USB device number 4 using ehci_h=
cd
> [ 4534.578617] usb 2-1.3: default language 0x0409
> [ 4534.586977] usb 2-1.3: udev 4, busnum 2, minor =3D 131
> [ 4534.586982] usb 2-1.3: New USB device found, idVendor=3D0781, idProduc=
t=3Db7b1
> [ 4534.586986] usb 2-1.3: New USB device strings: Mfr=3D3, Product=3D4, S=
erialNumber=3D5
> [ 4534.586990] usb 2-1.3: Product: MobileMate Micro
> [ 4534.586993] usb 2-1.3: Manufacturer: SanDisk
> [ 4534.586996] usb 2-1.3: SerialNumber: 000000062556
> [ 4534.587101] usb 2-1.3: usb_probe_device
> [ 4534.587104] usb 2-1.3: configuration #1 chosen from 1 choice
> [ 4534.587608] usb 2-1.3: adding 2-1.3:1.0 (config #1, interface 0)
> [ 4534.587647] drivers/usb/core/inode.c: creating file '004'
> [ 4534.587660] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0008
> [ 4534.663395] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4534.766099] Initializing USB Mass Storage driver...
> [ 4534.766148] usb-storage 2-1.3:1.0: usb_probe_interface
> [ 4534.766153] usb-storage 2-1.3:1.0: usb_probe_interface - got id
> [ 4534.766188] scsi6 : usb-storage 2-1.3:1.0
> [ 4534.766269] usbcore: registered new interface driver usb-storage
> [ 4534.766270] USB Mass Storage support registered.
> [ 4535.661802] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4535.766351] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   =
9407 PQ: 0 ANSI: 0
> [ 4535.767643] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [ 4535.898980] sd 6:0:0:0: [sdb] 3970048 512-byte logical blocks: (2.03 G=
B/1.89 GiB)
> [ 4535.900090] sd 6:0:0:0: [sdb] Write Protect is off
> [ 4535.900095] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
> [ 4535.900099] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 4535.903087] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 4535.903094] sdb: detected capacity change from 0 to 2032664576
> [ 4535.904362]  sdb: sdb1
> [ 4535.907076] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 4535.907080] sd 6:0:0:0: [sdb] Attached SCSI removable disk
> [ 4536.653092] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4536.653108] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4537.913797] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4539.910355] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4541.647227] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4542.645514] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4543.643771] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4543.667607] FAT: utf8 is not a recommended IO charset for FAT filesyst=
ems, filesystem will be case sensitive!
> [ 4545.903898] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4546.902177] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4547.900455] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4549.569452] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4550.567733] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4551.565889] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4552.708046] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4553.706073] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4554.704353] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4554.729833] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0008
> [ 4554.730007] hub 2-1:1.0: port 3, status 0100, change 0001, 12 Mb/s
> [ 4554.730130] usb 2-1.3: USB disconnect, device number 4
> [ 4554.730134] usb 2-1.3: unregistering device
> [ 4554.730137] usb 2-1.3: unregistering interface 2-1.3:1.0
> [ 4554.733024] usb 2-1.3: usb_disable_device nuking all URBs
> [ 4554.859918] hub 2-1:1.0: debounce: port 3: total 100ms stable 100ms st=
atus 0x100
> [ 4555.706750] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4556.705032] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4557.703175] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4558.801167] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4559.799572] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4560.797852] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4562.682477] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4563.680758] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4564.678865] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4566.615526] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4567.613894] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4567.628451] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4567.628461] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4570.616050] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4571.603085] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4572.661403] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4576.594247] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4576.594262] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4576.693951] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4577.332832] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4580.367491] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4580.598716] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4581.585393] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4582.643968] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4586.578163] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4586.578179] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4590.581885] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4591.572553] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4592.625991] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4600.563929] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4602.611204] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4602.727451] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4602.727460] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4604.288840] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4605.740008] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4606.706717] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4609.156772] phy0 -> rt2x00queue_flush_queue: Warning - Queue 2 failed =
to flush
> [ 4609.173337] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4611.041476] phy0 -> rt2x00queue_flush_queue: Warning - Queue 2 failed =
to flush
> [ 4611.085788] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4611.085793] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4611.193606] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4611.193614] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4611.193852] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4611.193859] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4613.357417] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4613.701285] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4613.701294] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4613.701532] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4613.701539] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4613.701655] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4613.869119] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4614.903044] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4615.581921] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4615.897372] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4616.580448] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4617.578356] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4620.233652] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4621.232057] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4622.230335] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4625.284948] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4626.283101] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4627.281381] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4627.522587] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4627.522601] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4627.688799] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4630.511935] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4630.558726] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4632.560777] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4632.684065] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4632.684077] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4633.171101] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4635.550125] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4636.908412] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4637.675339] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4637.742219] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4640.542270] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4641.899307] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4642.543697] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4642.850028] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4644.846556] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4645.844840] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4647.841316] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4647.841561] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4649.837828] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4652.525243] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4652.525252] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4655.714743] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4656.879224] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4656.879239] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4661.232230] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4661.870247] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4662.507414] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4666.223631] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4666.233114] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4666.862295] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4666.862303] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4667.231519] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4668.229631] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4668.609772] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4671.216527] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4673.212942] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4674.542543] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4675.540822] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4676.539226] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4678.599425] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4679.597695] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4680.326072] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4680.326087] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4681.202070] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4681.413940] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4683.590697] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4683.590713] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4685.319841] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4686.193954] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4686.317822] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4686.405825] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4686.405838] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4687.316142] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4687.434567] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4687.761130] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4688.413881] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4688.582215] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4689.719505] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4691.189351] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4691.400736] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4692.330880] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4693.577186] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4696.179616] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4696.392252] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4697.314667] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4697.555746] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4698.568625] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4700.006655] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4701.014922] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4701.383650] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4702.023051] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4702.745175] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4702.819671] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4703.031322] wlan1: deauthenticated from 10:9a:dd:89:4c:83 (Reason: 2)
> [ 4703.031337] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - =
CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 4703.033180] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - =
CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 4703.034424] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - =
CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 4703.035673] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - =
CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 4704.653510] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4704.657049] cfg80211: Calling CRDA to update world regulatory domain
> [ 4704.658252] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4707.177089] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4709.213521] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4709.221273] wlan1: authenticate with 10:9a:dd:89:4c:83 (try 1)
> [ 4709.222776] wlan1: authenticated
> [ 4710.818705] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4710.823372] wlan1: associate with 10:9a:dd:89:4c:83 (try 1)
> [ 4710.830144] wlan1: RX AssocResp from 10:9a:dd:89:4c:83 (capab=3D0x431 =
status=3D0 aid=3D2)
> [ 4710.830150] wlan1: associated
> [ 4710.830228] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - =
CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 4710.831612] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - =
CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 4710.832983] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - =
CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 4710.834480] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - =
CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 4716.149674] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4716.149679] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4716.165919] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4716.168039] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4716.168045] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4716.202479] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4716.236300] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4716.236313] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4716.247528] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4716.257881] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4716.282884] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4716.283591] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4716.311716] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4716.340677] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4716.360457] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4716.372320] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4716.377692] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4716.378677] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4716.381062] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4716.383336] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4716.384914] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4716.386556] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4716.396394] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4716.407253] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4716.408371] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4716.417131] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4716.417138] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4716.425846] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4716.430085] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4716.430090] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4716.438946] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4716.440440] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4716.494271] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4716.494598] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4716.501468] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4716.503092] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4716.504830] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4716.509572] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4716.510821] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4716.511842] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4716.528914] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4716.533285] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4716.539774] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4716.543140] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4716.543638] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4716.545260] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4716.548506] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4716.622760] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4716.660946] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4716.664810] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4716.665679] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4716.676788] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4716.684899] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4716.728823] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4717.108174] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4717.113779] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4717.116653] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4717.119023] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4717.119028] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4717.119397] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4717.119401] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4717.121772] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4717.122391] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4717.123276] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4717.124640] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4717.126135] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4717.129632] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4717.129877] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4717.129881] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4717.131373] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4717.131377] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4717.132499] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4717.140361] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4717.141483] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4717.143106] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4717.144976] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4717.144981] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4717.145851] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4717.146224] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4717.148222] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4717.158083] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4717.158950] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4717.159450] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4717.160323] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4717.161449] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4717.162199] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4717.164320] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4717.167190] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4717.167195] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4717.178300] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4717.178306] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4717.179168] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4717.182666] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4717.184036] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4717.184782] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4717.185659] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4717.186530] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4717.186535] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4717.187903] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4717.196140] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4717.196145] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4717.198595] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4717.198601] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4717.202651] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4717.202658] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4717.203001] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4717.232080] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4717.233073] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4717.233573] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4717.234704] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4717.235447] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4717.236569] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4717.236954] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4717.238690] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4717.240188] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4717.241185] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4717.242058] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4717.242559] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4717.243611] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4717.244055] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4717.245927] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4717.246434] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4717.247177] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4717.249175] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4717.249181] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4717.249545] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4717.255915] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4717.259656] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4717.296751] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4717.296760] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4717.297845] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4717.297850] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4717.330411] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4717.342889] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4717.343760] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4717.368474] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4717.371391] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4717.371964] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4717.371968] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4717.393055] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4717.411524] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4717.411768] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4717.415515] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4717.421628] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4717.439473] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4717.555397] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4717.580609] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4717.583225] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4717.585718] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4717.587095] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4717.609931] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4717.754933] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4717.797860] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4717.798732] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4717.814830] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4717.842667] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4717.842671] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4717.850404] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4717.850518] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4717.850522] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4717.854760] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4717.860246] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4717.862622] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4717.865861] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4717.869729] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4717.871726] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4717.873598] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4717.873602] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4717.877341] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4717.881457] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4717.887695] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4717.919020] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4717.955335] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4717.960699] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4717.975921] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4717.983280] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4718.008991] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4718.009361] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4718.013484] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4718.014478] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4718.018475] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4718.043312] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4718.076254] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4718.102708] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4718.107696] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4718.144013] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4718.497406] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4718.576017] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4718.577513] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4718.590990] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4718.645400] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4718.650260] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4718.653755] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4718.661365] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4718.661373] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4718.717399] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4718.725256] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4718.797139] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4718.833567] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4718.862399] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4718.872003] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4718.876870] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4718.880863] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4718.909817] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4718.976703] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4719.336210] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4719.340694] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4719.522762] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4719.557701] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4719.815132] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4719.935179] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4719.994572] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4720.142819] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4720.190362] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4720.197592] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4720.202708] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4720.202715] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4720.238524] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4720.262488] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4720.382407] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4720.546371] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4720.552107] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4720.571455] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4720.588921] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4720.605886] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4720.609887] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4720.642704] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4720.857587] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4720.857602] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4720.889650] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4721.026043] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4722.043665] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4722.290190] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4722.789992] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4723.022350] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4723.044056] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4723.044065] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4723.278286] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4723.301119] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4723.309479] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4723.333063] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4723.349038] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4723.396960] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4723.524864] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4723.556680] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4723.776314] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4723.964232] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4723.966221] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4723.986066] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4723.989308] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4724.011892] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4724.024251] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4724.043841] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4724.067803] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4724.067813] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4724.073038] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4724.395364] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4724.738635] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4725.249890] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4725.996480] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4726.052368] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4726.499737] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4726.524312] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4726.862985] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4726.863230] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4726.894926] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4726.894934] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4727.501757] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4727.501767] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4729.717592] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4729.734279] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4729.897627] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4729.897636] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4729.897872] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4729.897879] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4729.897997] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4729.898003] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4729.961644] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4729.971247] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4729.991962] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4729.994079] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4729.995078] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4729.995082] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4730.006193] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4730.016170] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4730.023907] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4730.034268] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4730.047616] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4730.057968] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4730.067957] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4730.073444] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4730.245277] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4730.245296] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4730.292932] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4730.296938] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4730.374681] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4730.696205] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4730.828897] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4730.891288] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4730.983878] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4731.045398] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4731.135499] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4731.521830] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4732.026707] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4732.231980] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4732.273657] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4732.284759] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4732.284772] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4732.304223] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4732.318077] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4732.421278] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4732.495525] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4732.533087] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4732.625550] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4732.964339] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4732.990543] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4732.999030] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4733.009383] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4733.065121] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4733.065535] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4733.067286] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4733.081632] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4733.082380] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4733.083005] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4733.127434] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4733.128433] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4733.233508] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4733.384114] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4733.491306] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4733.903221] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4734.010415] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4734.082417] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4734.941683] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4735.052619] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4735.304186] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4736.881960] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4737.018477] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4737.133033] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4738.874029] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4738.905848] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4738.905856] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4740.343250] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4741.170323] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4741.780770] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4741.888834] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4741.940481] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4741.948852] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4742.323961] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4742.579520] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4743.673381] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4745.815064] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4745.815073] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4745.869598] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4746.834062] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4746.931893] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4753.312644] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4753.329732] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4753.329736] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4753.369550] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4753.374036] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4753.441419] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4757.596013] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4758.774968] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4758.791944] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4758.797309] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4758.805922] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4758.822516] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4758.969897] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4759.121874] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4759.137224] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4759.190300] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4762.352692] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4762.407966] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4762.863791] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4762.863805] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4762.927816] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4762.927824] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4764.141726] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4766.377749] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4766.489926] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4766.677606] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4766.801891] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4766.824851] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4767.591658] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4767.974861] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4769.444459] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4771.843949] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4772.101128] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4772.447163] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4772.447178] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4773.095043] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4777.272715] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4777.281955] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4777.285069] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4777.288186] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4777.291056] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4777.291060] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4777.293677] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4777.293681] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4777.296312] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4777.296316] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4777.338604] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4777.843360] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4777.849594] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4777.930333] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4777.953293] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4778.089419] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4778.089431] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4778.360964] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4778.536910] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4778.848126] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4779.247436] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4781.878529] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4783.080457] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 4
> [ 4783.080472] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4783.832287] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4783.836526] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4783.942718] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4784.526465] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4787.140835] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4788.071606] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4788.071620] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4788.893568] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4788.952096] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4793.063251] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 18
> [ 4793.274637] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4795.307756] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4795.816257] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4795.922325] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4796.277203] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 25
> [ 4796.329996] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4796.505443] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4798.057768] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4798.057786] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4802.282736] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4802.921628] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4803.049369] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4808.044923] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4809.210915] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4809.557943] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4810.556176] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4811.554458] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4811.598174] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4811.598183] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4812.552611] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4814.293642] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4815.507554] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4815.876425] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 41
> [ 4816.254527] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4816.507093] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 43
> [ 4816.529672] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4816.529680] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4816.590440] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4816.593693] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4818.063158] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4818.590251] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4818.701886] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4819.466111] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4819.971620] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4820.970027] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4821.968306] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4826.532187] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4827.530466] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4828.528621] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4830.844769] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4831.842907] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4832.841188] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4834.270725] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4836.267282] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4837.149762] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4837.149771] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 3
> [ 4838.507296] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4838.507664] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
> [ 4838.507677] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4839.241904] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4839.353664] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4841.549928] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4845.295469] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4845.295715] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4846.141761] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4846.541063] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4846.541077] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4849.024445] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4849.136722] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4849.136730] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4849.136969] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4849.136976] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4849.137218] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4849.292330] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4851.124764] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed =
to flush
> [ 4851.141389] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0=
 status timed out, invoke forced tx handler
> [ 4853.077338] phy0 -> rt2x00queue_flush_queue: Warning - Queue 2 failed =
to flush
> [ 4853.094023] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4853.094273] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4853.094280] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4853.233783] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4853.409234] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4854.483132] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4855.477543] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4856.475824] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2=
 status timed out, invoke forced tx handler
> [ 4858.887935] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4886.065570] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 7
> [ 4886.065578] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 8
> [ 4886.106006] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 9
> [ 4886.106015] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 10
> [ 4886.295548] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 11
> [ 4886.343340] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 12
> [ 4886.550972] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 13
> [ 4886.822514] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 14
> [ 4886.858453] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 15
> [ 4886.860517] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 16
> [ 4886.860521] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 17
> [ 4886.881293] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 19
> [ 4886.934575] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 20
> [ 4886.987358] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 21
> [ 4886.991224] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 22
> [ 4887.030032] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 23
> [ 4887.038522] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 24
> [ 4887.044754] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 26
> [ 4887.051121] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 27
> [ 4887.053614] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 28
> [ 4887.085307] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 29
> [ 4887.085311] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 30
> [ 4887.096053] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 31
> [ 4887.096060] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 32
> [ 4887.097535] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 33
> [ 4887.098297] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 34
> [ 4887.098301] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 35
> [ 4887.342990] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 36
> [ 4887.345613] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 37
> [ 4887.724960] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 38
> [ 4887.758943] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 39
> [ 4887.758947] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 40
> [ 4887.945081] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 42
> [ 4888.166199] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 44
> [ 4888.166213] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 45
> [ 4888.234928] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
> [ 4888.235152] hub 2-1:1.0: port 2, status 0101, change 0001, 12 Mb/s
> [ 4888.305456] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 46
> [ 4888.343766] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 47
> [ 4888.359697] hub 2-1:1.0: debounce: port 2: total 100ms stable 100ms st=
atus 0x101
> [ 4888.418508] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 48
> [ 4888.431508] usb 2-1.2: new high speed USB device number 5 using ehci_h=
cd
> [ 4888.437478] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 49
> [ 4888.438351] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 50
> [ 4888.438599] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 51
> [ 4888.441094] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 52
> [ 4888.441595] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 53
> [ 4888.442468] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 54
> [ 4888.526528] usb 2-1.2: default language 0x0409
> [ 4888.534886] usb 2-1.2: udev 5, busnum 2, minor =3D 132
> [ 4888.534889] usb 2-1.2: New USB device found, idVendor=3D0781, idProduc=
t=3Db7b1
> [ 4888.534891] usb 2-1.2: New USB device strings: Mfr=3D3, Product=3D4, S=
erialNumber=3D5
> [ 4888.534894] usb 2-1.2: Product: MobileMate Micro
> [ 4888.534895] usb 2-1.2: Manufacturer: SanDisk
> [ 4888.534896] usb 2-1.2: SerialNumber: 000000062556
> [ 4888.534985] usb 2-1.2: usb_probe_device
> [ 4888.534988] usb 2-1.2: configuration #1 chosen from 1 choice
> [ 4888.535511] usb 2-1.2: adding 2-1.2:1.0 (config #1, interface 0)
> [ 4888.535541] usb-storage 2-1.2:1.0: usb_probe_interface
> [ 4888.535545] usb-storage 2-1.2:1.0: usb_probe_interface - got id
> [ 4888.543142] scsi7 : usb-storage 2-1.2:1.0
> [ 4888.543243] drivers/usb/core/inode.c: creating file '005'
> [ 4888.543259] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
> [ 4888.718747] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 55
> [ 4889.218135] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 56
> [ 4889.252076] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 57
> [ 4889.253073] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 58
> [ 4889.254000] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 59
> [ 4889.542683] scsi 7:0:0:0: Direct-Access     Generic  STORAGE DEVICE   =
9407 PQ: 0 ANSI: 0
> [ 4889.544025] sd 7:0:0:0: Attached scsi generic sg2 type 0
> [ 4889.682047] sd 7:0:0:0: [sdb] 3970048 512-byte logical blocks: (2.03 G=
B/1.89 GiB)
> [ 4889.683163] sd 7:0:0:0: [sdb] Write Protect is off
> [ 4889.683168] sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
> [ 4889.683171] sd 7:0:0:0: [sdb] Assuming drive cache: write through
> [ 4889.686035] sd 7:0:0:0: [sdb] Assuming drive cache: write through
> [ 4889.686042] sdb: detected capacity change from 0 to 2032664576
> [ 4889.687427]  sdb: sdb1
> [ 4889.690149] sd 7:0:0:0: [sdb] Assuming drive cache: write through
> [ 4889.690153] sd 7:0:0:0: [sdb] Attached SCSI removable disk
> [ 4891.839245] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 60
> [ 4891.845730] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 61
> [ 4897.795221] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 62
> [ 4897.847141] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 63
> [ 4897.951087] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 0
> [ 4903.441354] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 1
> [ 4903.763687] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 2
> [ 4903.984305] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 5
> [ 4903.984311] phy0 -> rt2800_txdone_entry_check: Warning - TX status rep=
ort missed for queue 2 entry 6
>=20
> --=20
> balbi



--=20
balbi

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2kdPAAoJEAv8Txj19kN1CoUH/A2WHlhdkenKwCyRyyphj2DX
VQtd87ZFCIrbCzEZjewlR2S0YpL0vBLOFVabUgab82HykaAfmRDD3uaCkNZgZebV
DVPHeJgzWhmlCY3BThSoQvesh8bXEDbsmB8XCKDKLDCItUN2g48wxYlc25p7yvrB
PewsEcxfO1GMb//3oTbEGH0UaJYqQDW/SV6dr1sYrRuWhBdn66bsOLKs73qX71NB
1qXRyBtSOaMW9w7Ohwxc2qnyNairIm/yXYam3OAezft/LWFa+jripzr4lQJiJGlF
3FumhimygV0JaOXQlsthmQQ0PUADYI6zYP0ePFC9L79ewqvozexVzxRkzxiE7Y8=
=Gk6s
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
